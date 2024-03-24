resource "aws_lambda_function" "myfunc {
    filename            = data.archive_file.zip.output_path
    source_code_hash    = data.archive_file.zip.outputbase64sha256
    function_name       = "myfunc"
    role                = aws_iam_role.iam_for_lambda.arn  
    handler             = "func.handler"
    runtime             = "python3.8"
}

resource "aws_iam_role" "iam_for_lambda" {
    name = "iam_for_lambda"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
         "Action": "sts:AssumeRole",
         "Principal": {
            "Service": "lamdba.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
}
EOF
}

data "archive_file" "zip" {
    type        = "zip"
    source_dir  = "${path.module}/lambda/"
    output_path = "${path.module}/packedlambda.zip"
}

resource "aws_iam_policy" "iam_policy_for_resume_project" {

    name        = "aws_iam_policy_forterraform_resume_project_policy"
    path        = "/"
    description = "AWS IAM Policy for mananging the resume project role"
        polic = jsonencode (
            {
                "Version"   : "2012-10-17",
                "Statement" :[
                    {
                        "Action" [
                            "logs:CreateLogGroup",
                            "logs:CreateLogStream",
                            "logs:PutLogEvents"
                        ],
                        "Resource" : "arn:aws:logs:*:*:*:",
                        "Effect" : "Allow"
                        },
                    {
                        "Effect" : "Allow",
                        "Action" : [
                            "dynamodb:UpdateItem",
                            "dynamodb:GetItem"
                        ],
                        "Resource" : "arn.aws:dynamodb:*:*:table/Cloudresume-Challenge"
                    },
                ]
            })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
    role    = aws_iam_role.iam_for_lambda.name
    policy_arn = aws_iam_policy.iam_policy_for_resume_project.arn 
}

resource "aws_lambda_function_url" "url1" {
    function_name       = aws_lamda_function.myfunc.function_name
    authorization_type  = "NONE"

    cors {
        allow_credentials = true 
        allow_origins       = ["*"]
        allow_methods       = ["*"]
        allow_headers       = ["date", "keep-alive"]
        expose_headers      = ["keep-alive", "date"]
        max_age             = 86400
    }
}
