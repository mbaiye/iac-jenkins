variable "aws_region" { 
	default = "us-east-1"
 }  

provider "aws" { 
	region = var.aws_region 
} 

resource "aws_s3_bucket" "terraform_state" { 
	bucket = "terraform-state-mobann-jenkins-live" 
    
    lifecycle { 
    	prevent_destroy = false 
    } 
    
    versioning { 
    	enabled = true 
   } 
   
   server_side_encryption_configuration { 
   		rule { 
        	apply_server_side_encryption_by_default { 
            	sse_algorithm = "AES256" 
            } 
        } 
   } 
}