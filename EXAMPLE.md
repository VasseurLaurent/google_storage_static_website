# Example HTTPS frontend

```
module "website" {
  source                 = "git@github.com:VasseurLaurent/google_storage_static_website.git"
  website_url            = "test.yourdomain.com"
  location               = "US"
  storage_class          = "standard"
  create_log_bucket      = true
  website_default_public = true
  labels = {
    department = "marketing",
    billing    = "it"
  }
  enable_https = true
}
```
# Example HTTP with CORS

```
module "website" {
  source                 = "git@github.com:VasseurLaurent/google_storage_static_website.git"
  website_url            = "test.yourdomain.com"
  location               = "US"
  storage_class          = "standard"
  create_log_bucket      = true
  website_default_public = true
  labels = {
    department = "marketing",
    billing    = "it"
  }
  enable_https = false
  cors = [{
    max_age_seconds = 3600
    methods         = ["GET", "POST"]
    origins         = ["others.anotherdomain.com"]
    response_header = ["*"]
  }]
}
```