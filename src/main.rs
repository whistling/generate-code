use actix_web::{web, App, HttpResponse, HttpServer, Responder};

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .route("/ping", web::get().to(ping))
            .route("/", web::get().to(health))
    })
    .bind("0.0.0.0:8090")?
    .run()
    .await
}

async fn health() -> impl Responder {
    HttpResponse::Ok().body("health")
}

async fn ping() -> impl Responder {
    HttpResponse::Ok().body("pong")
}
