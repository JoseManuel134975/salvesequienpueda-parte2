# Creación del bucket
resource "aws_s3_bucket" "s3" {
  bucket        = "bucket-jose-manuel"
  force_destroy = true # Elimina el bucket y su contenido si es destruido
}

# Políticas de acceso público al bucket
# Todo en false porque sino no podemos acceder*
resource "aws_s3_bucket_public_access_block" "bucket_public_block" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = false  # Permite ACLs públicas
  block_public_policy     = false  # Permite políticas públicas
  ignore_public_acls      = false  # No ignora ACLs públicas
  restrict_public_buckets = false  # No restringe el acceso público al bucket
}

# Política para permitir acceso público de lectura y escritura
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject" # Nombre
        Effect    = "Allow" # Permite o deniega
        Principal = "*" # Cualquier persona persona puede hacer las siguientes acciones:
        Action = [
          "s3:GetObject", # Leer
          "s3:PutObject" # Escribir
        ]
        Resource = "${aws_s3_bucket.s3.arn}/*" # La política se aplica a TODOS los objetos del bucket
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.bucket_public_block]
}

# Configura el bucket como servidor web estático
resource "aws_s3_bucket_website_configuration" "index_of_bucket" {
  bucket = aws_s3_bucket.s3.id

  index_document {
    suffix = "index.html" # En mi caso, es este
  }
}

# Búsqueda de archivos
data "local_file" "web_files" {
  for_each = fileset("../src", "**")            # Busca todos los archivo dentro de 'src' (mi página web)
  filename = "${abspath("../src")}/${each.key}" # Obtiene la ruta completa del archivo por si hace falta más adelante...
}

# Subida de archivos al bucket
resource "aws_s3_object" "bucket_objects" {
  for_each = data.local_file.web_files
  bucket   = aws_s3_bucket.s3.id
  key      = each.key # Consigue la ruta de cada archivo (anteriormente => ${each.key})
  source   = each.value.filename # Escoge el archivo que se va a subir
  # Establece el tipo de cada archivo dependiendo de su extensión
  content_type = lookup({
    "html" = "text/html"
    "css"  = "text/css"
    "js"   = "application/javascript"
  }, regex("^.*\\.([a-z]+)$", each.key)[0], "application/octet-stream")
}