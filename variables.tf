variable "labels" {
  type        = map(string)
  description = "Labels to add to each resource deployed"
  default     = {}
}

variable "website_url" {
  type        = string
  description = "Website url and bucket name"
}

variable "location" {
  type        = string
  description = "Bucket location"
  default     = "US"
}

variable "storage_class" {
  type        = string
  description = "Storage class of the bucket"
  default     = "standard"
  validation {
    condition     = contains(["standard", "multi_regional", "regional", "nearline", "coldline", "archive"], lower(var.storage_class))
    error_message = "The storage_class specified is wrong, it must be 'standard','multi_regional', 'regional', 'nearline', 'coldline' or 'archive'."
  }
}

variable "force_destroy" {
  type        = bool
  description = "Allow to delete all files before deleting the bucket"
  default     = true
}

variable "main_page_suffix" {
  type        = string
  description = "Default website page"
  default     = "index.html"
}

variable "not_found_page" {
  type        = string
  description = "Default 404 error"
  default     = "404.html"
}

variable "cors" {
  type = list(object({
    max_age_seconds = number
    methods         = list(string),
    origins         = list(string),
    response_header = list(string)
    })
  )

  description = "Define cors permissions"
  default     = []
}

variable "create_log_bucket" {
  type    = bool
  default = false
}
variable "log_bucket" {
  type        = string
  description = "Specify the bucket to store logs from the website bucket, if not specified, no log will be configured"
  default     = null
}

variable "logs_retention" {
  type        = number
  description = "Set logs retention on logs bucket"
  default     = 90
}

variable "website_default_public" {
  type        = bool
  description = "Set to true to set the website bucket as public"
  default     = false
}

variable "enable_https" {
  type        = bool
  description = "Enable HTTPS access to the static website, if yes, a GCP certificate will be generated"
  default     = false
}

variable "create_dns_record" {
  type        = bool
  description = "To create a SSL certificate, you need to create a DNS record, with this bool variable it can create the DNS record only if the domain is managed by GCP"
  default     = false
}

variable "managed_zone_dns_name" {
  type        = string
  description = "if create_dns_record is set to yes, you can specify the name of the zone with this variable"
  default     = ""
}
