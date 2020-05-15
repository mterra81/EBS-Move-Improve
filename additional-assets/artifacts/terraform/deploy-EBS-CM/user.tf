############################################
# Create IAM Users
############################################


resource "oci_identity_user" "ebs-cm-admin" {
  name           = "ebscm.admin"
  description    = "EBS Cloud Manager administrator"
  compartment_id = "${var.tenancy_ocid}"
}

resource "oci_identity_ui_password" "ebs-cm-admin-pwd" {
  user_id = "${oci_identity_user.ebs-cm-admin.id}"
}


resource "oci_identity_api_key" "api-key1" {
  user_id = "${oci_identity_user.ebs-cm-admin.id}"

  key_value = <<EOF
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsu7jS/vPNx7N3XuXOoVk
8J3mbFCWMHu5paRee+Tpj9yieesCte1hWOg8CDbVi6Bz8c8n+dept07EvaLAjPG6
L16E0uXPrVAcrKLd8E72IMiy1FDNWC4GsFQNRVSBJZx+/+ctLoRL49Xg3d8FY67r
AoficufECeYGCMGVNWthWPUipC88yOFBcWKhBItrs+FRXEL1NBdr0GIrM8C5RNUK
zxSO42MvN4alZkHda72Q3cTSfp74NkLDlNuemjQBQME7lYMV+8jrzoFZuZe18bM3
RxJjtCHieoezlGDm5tvBFmyWcYH46vY/TmaJLY0CgsOjY9JluzF0wcPOckk2CUFN
vwIDAQAB
-----END PUBLIC KEY-----
EOF
}
