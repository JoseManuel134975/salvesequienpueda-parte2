# Bucket principal para el sitio web
resource "aws_s3_bucket" "s3" {
  bucket        = "bucket-jose-manuel"
  force_destroy = true # Elimina el bucket y su contenido si es destruido
}

# Configuración de acceso público para el bucket
resource "aws_s3_bucket_public_access_block" "bucket_public_block" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = false  # Permite ACLs públicas
  block_public_policy     = false  # Permite políticas públicas
  ignore_public_acls      = false  # No ignora ACLs públicas
  restrict_public_buckets = false  # No restringe el acceso público al bucket
}

# Política para permitir acceso público de lectura
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.s3.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.bucket_public_block]
}

# Configuración del sitio web estático
resource "aws_s3_bucket_website_configuration" "index_of_bucket" {
  bucket = aws_s3_bucket.s3.id

  index_document {
    suffix = "index.html"
  }
}

# Subida de archivos al bucket
data "local_file" "web_files" {
  for_each = fileset("../src", "**")            # Itera sobre todos los archivos en la carpeta `src`
  filename = "${abspath("../src")}/${each.key}" # Obtiene la ruta completa del archivo
}

resource "aws_s3_object" "bucket_objects" {
  for_each = data.local_file.web_files
  bucket   = aws_s3_bucket.s3.id
  key      = each.key
  source   = each.value.filename
  content_type = lookup({
    "html" = "text/html"
    "css"  = "text/css"
    "js"   = "application/javascript"
  }, regex("^.*\\.([a-z]+)$", each.key)[0], "application/octet-stream")
}