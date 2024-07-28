
variable "release_label" {}
variable "instance_profile" {}
variable "service_role" {}
variable "log_uri_bucket" {}
variable "aws_subnet" {}
#variable "bucket_name" {}

resource "aws_emr_cluster" "cluster" {
  name          = "emr-pyspark-ml"
  release_label = var.release_label
  applications  = ["Spark", "Hadoop"] 
  service_role = var.service_role
  log_uri = "s3://${var.log_uri_bucket}"

  termination_protection            = false
  #keep_job_flow_alive_when_no_steps = false

  ec2_attributes {
    subnet_id                         = var.aws_subnet 
    emr_managed_master_security_group = aws_security_group.master_security_group.id
    emr_managed_slave_security_group  = aws_security_group.worker_security_group.id
    instance_profile                  = var.instance_profile 
  }

  master_instance_group {
    instance_type = "m5.xlarge"
  }

  core_instance_group {
    instance_type  = "m5.xlarge"
    instance_count = 2

    # ebs_config {
    #   size                 = "40"
    #   type                 = "gp2"
    #   volumes_per_instance = 1
    # }

    #bid_price = "0.30"

  }

  #ebs_root_volume_size = 100


#   bootstrap_action {
#     name = "Installing Additional Python Packages"
#     path = "s3://${var.bucket_name}/scripts/bootstrap.sh"

#   }

    step = [

      {
        name = "Copia os scripts python do S3 para o ec2"
        action_on_failure = "TERMINATE_CLUSTER"

        hadoop_jar_step = [{
            jar = "command-runner.jar",
            args = ["aws", "s3", "cp", "s3://${var.name_bucket}/pipelines", "home/hadoop/pipelines/", "--recursive"]
        }
        ]
      },

      {
        name = "Copia a pasta de logs para o arquivo EC2"
        action_on_failure = "TERMINATE_CLUSTER"

        hadoop_jar_step = [{
            jar = "command-runner.jar",
            args = ["aws", "s3", "cp", "s3://${var.name_bucket}/logs", "home/hadoop/logs/", "--recursive"]
        }
        ]
      },

      {
        name = "Executa Scripts Python"
        action_on_failure = "CONTINUE"

        hadoop_jar_step = [{
            jar = "command-runner.jar",
            args = ["spark-submit", "home/hadoop/pipelines/projeto2.py"]
        }
        ]
      }



    ]

  configurations_json = <<EOF
  [
    {
          "Classification": "spark-defaults",
          "Properties": {
            "JAVA_HOME": "/usr/lib/jvm/java-1.8.0",
            "spark.pyspark.python": "/home/hadoop/conda/bin/python",
            "spark.dynamicAllocation.enabled": "true",
            "spark.network.timeout":"800s",
            "spark.executor.heartbeatInterval":"60s"
          }
    }
  ]
EOF

}