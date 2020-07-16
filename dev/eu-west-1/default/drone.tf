resource "aws_kms_key" "kms_drone" {
  description             = "KMS Key used to encrypt / decrypt drone secrets"
  deletion_window_in_days = 30
  key_usage               = "ENCRYPT_DECRYPT"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_alias" "kms_alias_drone" {
  name          = "alias/drone-containerdays"
  target_key_id = aws_kms_key.kms_drone.key_id
}

resource "aws_iam_role" "role_drone" {
  name               = "DroneTerraformContainerDays"
  assume_role_policy = data.aws_iam_policy_document.assume_policy_drone.json
}

data "aws_iam_policy_document" "assume_policy_drone" {
  statement {
    effect = "Allow"
    principals {
      identifiers = [
        data.aws_kms_secrets.drone.plaintext["trusted_account_arn"],
      ]
      type = "AWS"
    }
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      values   = [data.aws_kms_secrets.drone.plaintext["external_id"]]
      variable = "sts:ExternalId"
    }
  }
}

data "aws_kms_secrets" "drone" {
  secret {
    name    = "external_id"
    payload = "AQICAHhPn3bhm79OXfKYrZ9HKfQtQxgHtRJbifh4Y7xEvZFjRgH2ofFooKuJidnrJydX9MwUAAAAizCBiAYJKoZIhvcNAQcGoHsweQIBADB0BgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDKmnJVCBjT2TLjQsiwIBEIBHsQzL5CDQ3sR4JT05z9CHchwcXlvLU51rbjOZ+swMZntYKoDVgdBIo13wzstUenhMVf91ogZBg+rhMDdmEo48u0defu6ecNE="
  }

  secret {
    name    = "trusted_account_arn"
    payload = "AQICAHhPn3bhm79OXfKYrZ9HKfQtQxgHtRJbifh4Y7xEvZFjRgFQlXrUhtqi8Jmq7os5k60GAAAAfDB6BgkqhkiG9w0BBwagbTBrAgEAMGYGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMq1zIRlzcPLfIIuOWAgEQgDnF9NC2tvPZAnixKRny/N8sRm6eXFIP54tJXFuFGyrx7d9EtViuESgJ7/CmqCytInb23mKFaeC+DWU="
  }
}

resource "aws_iam_role_policy_attachment" "policy_attchment_drone" {
  role       = aws_iam_role.role_drone.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
