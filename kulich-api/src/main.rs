use actix_web::{get, App, HttpResponse, HttpServer, Responder};
use clap::Parser;

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Args {
    #[arg(short, long, default_value = "127.0.0.1")]
    address: String,

    #[arg(short, long, default_value_t = 8080)]
    port: u16,
}

#[get("/")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().body("Hi")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let args = Args::parse();

    HttpServer::new(|| {
        App::new()
            .service(hello)
    })
    .bind((args.address, args.port))?
    .run()
    .await
}
