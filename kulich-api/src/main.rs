use actix_web::{get, post, web, App, HttpResponse, HttpServer};
use clap::Parser;
use deadpool_postgres::{Config, ManagerConfig, RecyclingMethod, Runtime, Client, Pool};
use tokio_postgres::NoTls;
use actix_web_httpauth::extractors::basic::BasicAuth;
use serde::Deserialize;
use chrono::NaiveDateTime;

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Args {
    #[arg(short, long, default_value = "127.0.0.1")]
    addr: String,

    #[arg(short, long, default_value_t = 8080)]
    port: u16,

    #[arg(short, long, default_value = "data")]
    database: String,
}

#[derive(Deserialize)]
struct LocationData {
    time: NaiveDateTime,
    lat: f64,
    lon: f64,
}

async fn authenticate(db: &Client, auth: &BasicAuth) -> Option<i32> {
    let username = auth.user_id();
    let Some(password) = auth.password() else { return None };
    let stmt = db.prepare_cached("SELECT uid, password FROM users WHERE username = $1").await.unwrap();
    let rows = db.query(&stmt, &[&username]).await.unwrap();
    if rows.len() != 1 { return None };
    let pwd: String = rows[0].get(1);
    if pwd != password { return None };
    Some(rows[0].get(0))
}

#[get("/uid")]
async fn get_uid(pool: web::Data<Pool>, auth: BasicAuth) -> HttpResponse {
    let db = pool.get().await.unwrap();
    let uid = authenticate(&db, &auth).await;
    HttpResponse::Ok().json(uid)
}

#[post("/location")]
async fn post_location(pool: web::Data<Pool>, auth: BasicAuth, data: web::Json<LocationData>) -> HttpResponse {
    let db = pool.get().await.unwrap();
    let Some(uid) = authenticate(&db, &auth).await else {
        return HttpResponse::Unauthorized().into();
    };

    let stmt = db.prepare_cached("INSERT INTO locations (uid, time, lat, lon) VALUES ($1, $2, $3, $4)").await.unwrap();
    db.execute(&stmt, &[&uid, &data.time, &data.lat, &data.lon]).await.unwrap();
    
    HttpResponse::Ok().into()
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let args = Args::parse();

    let mut cfg = Config::new();
    cfg.dbname = Some(args.database);
    cfg.manager = Some(ManagerConfig {
        recycling_method: RecyclingMethod::Fast,
    });
    let pool = cfg.create_pool(Some(Runtime::Tokio1), NoTls).unwrap();

    let server = HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(pool.clone()))
            .service(get_uid)
            .service(post_location)
    });

    let fut = server
        .bind((args.addr.clone(), args.port.clone()))?  // TODO bind_uds
        .run();

    println!("Server running at {}:{}", args.addr, args.port);
    fut.await
}
