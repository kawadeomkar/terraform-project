resource "aws_instance" "pipeline" {
    ami = "${lookup(vars.AMIS, vars.AWS_REGION)}"
    instance_type = "t2.micro"
}
