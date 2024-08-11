use actix_web::{get, post, web, App, HttpResponse, HttpServer};
use clap::Parser;
use deadpool_postgres::{Config, ManagerConfig, RecyclingMethod, Runtime, Client, Pool};
use tokio_postgres::NoTls;

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

async fn auth(db: &Client, username: &str, password: &str) -> Option<i32> {
    let stmt = db.prepare_cached("SELECT id, password FROM users WHERE username = $1").await.unwrap();
    let rows = db.query(&stmt, &[&username]).await.unwrap();
    if rows.len() != 1 { return None };
    let pwd: String = rows[1].get(1);
    if pwd != password { return None };
    Some(rows[0].get(0))
}

#[get("/uid")]
async fn get_uid(pool: web::Data<Pool>) -> HttpResponse {
    let db = pool.get().await.unwrap();
    let uid = auth(&db, "lampin", "assword").await;
    HttpResponse::Ok().json(uid)
}

#[get("/location")]
async fn get_location(pool: web::Data<Pool>) -> HttpResponse {
    let db = pool.get().await.unwrap();
    let uid = auth(&db, "lampin", "assword").await;
    HttpResponse::Ok().json(uid)
}

#[post("/location")]
async fn post_location(pool: web::Data<Pool>) -> HttpResponse {
    let db = pool.get().await.unwrap();
    let uid = auth(&db, "lampin", "assword").await;
    HttpResponse::Ok().json(uid)
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
            .service(hello)
    })
    .bind((args.addr.clone(), args.port.clone()))?
    .run();

    println!("Server running at http://{}:{}", args.addr, args.port);
    server.await
}
