resource "aws_iam_instance_profile" "nodejs_instance_profile" {
    role = aws_iam_role.nodejs_instance_logs_role.name
}

resource "aws_iam_role" "nodejs_instance_logs_role" {
    name_prefix = "${var.instance_name}-role-"
    assume_role_policy = data.aws_iam_policy_document.nodejs_instance_trust_policy.json
}

resource "aws_iam_role_policy" "nodejs_instance_logs_policy" {
    policy = data.aws_iam_policy_document.jenkins_instance_permissions_policy.json
    role = aws_iam_role.nodejs_instance_logs_role.id
}


data "aws_iam_policy_document" "nodejs_instance_trust_policy" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }

    }
}

data "aws_iam_policy_document" "nodejs_instance_permissions_policy"{
    statement {
        sid = 1
        effect = "Allow"
        actions = [
            "logs:CreatLogGroup"
        ]

        resources = [
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
        ]
    }

    statement {
        sid = 2
        effect = "Allow"
        actions = [
            "logs:CreateLogStream",
            "logs:DescribeLogStreams",
            "logs:PutLogEvents"
        ]

        resources = [aws_cloudwatch_log_group.lbitc_nodejs_instance_logs.arn]
    }   

}

  
 