provider "google" {
  project     = "go-gcp-bill-saver-325714"
  region      = "europe-west1"
  credentials = "/home/joseramon/Downloads/go-gcp-bill-saver-325714-64ad594e8fb5.json"
}

variable "project_name" {
  default = "go-gcp-bill-saver"
}

resource "google_storage_bucket" "bucket" {
  name = var.project_name
  location      = "EU"
}

resource "google_storage_bucket_object" "archive" {
  name   = "list_compute_engine.zip"
  bucket = google_storage_bucket.bucket.name
  source = "../../cmd/list_compute_engine/main.go"
}

resource "google_cloudfunctions_function" "function" {
  name        = "list_compute_engine"
  description = "List Compute Engine"
  runtime     = "go116"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "ListComputeEngine"

  environment_variables = {
    power_off = "on"
  }
  service_account_email = " go-gcp-bill-saver-325714@go-gcp-bill-saver-325714.iam.gserviceaccount.com"
//    service_account_email = google_service_account.service_account.email
}


//resource "google_cloud_scheduler_job" "job" {
//  name             = "cloud-function-tutorial-scheduler"
//  description      = "Trigger the ${google_cloudfunctions_function.function.name} Cloud Function every 10 mins."
//  schedule         = "*/10 * * * *" # Every 10 mins
//  time_zone        = "Europe/Dublin"
//  attempt_deadline = "320s"
//
//  http_target {
//    http_method = "GET"
//    uri         = google_cloudfunctions_function.function.https_trigger_url
//
//    oidc_token {
//      service_account_email = google_service_account.service_account.email
//    }
//  }
//}

# IAM entry for all users to invoke the function
//resource "google_cloudfunctions_function_iam_member" "invoker" {
//  project        = google_cloudfunctions_function.function.project
//  region         = google_cloudfunctions_function.function.region
//  cloud_function = google_cloudfunctions_function.function.name
//
//  role   = "roles/cloudfunctions.invoker"
//  member = "allUsers"
//}

# resource "google_cloudfunctions_function_iam_member" "invoker" {
#   project        = google_cloudfunctions_function.function.project
#   region         = google_cloudfunctions_function.function.region
#   cloud_function = google_cloudfunctions_function.function.name

#   role   = "roles/cloudfunctions.invoker"
#   member = "allUsers"
# }


