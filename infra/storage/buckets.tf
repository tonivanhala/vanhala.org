resource "random_id" "website-bucket-prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "website" {
    name = "${random_id.website-bucket-prefix.hex}-website"
    location = var.location
    uniform_bucket_level_access = true
    website {
        main_page_suffix = "index.html"
        not_found_page   = "404.html"
    }
}

# Make bucket public by granting allUsers storage.objectViewer access
resource "google_storage_bucket_iam_member" "public-view" {
  bucket = google_storage_bucket.website.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
