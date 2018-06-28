resource "aws_instance" "example" {
    ami = "${lookup(vars.AMIS, vars.AWS_REGION)}"
    instance_type = "t2.micro"
}
