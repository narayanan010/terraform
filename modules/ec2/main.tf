data "template_file" "hostname" {
    template = "${file("${path.module}/init/hostname.sh")}"
}

data "template_cloudinit_config" "capterra-cloudinit" {
    gzip = false
    base64_encode=false

    part{
        content_type = "text/x-shellscript"
        content = "${data.template_file.hostname.rendered}"
    }
}

resource "aws_instance" "this" {
    count = "${var.ec2_count}"
    user_data = "${data.template_cloudinit_config.capterra-cloudinit.rendered}"
    ami = "${var.ec2_ami}"
    instance_type = "${var.ec2_instance_type}"
    availability_zone = "${var.ec2_aws_region}${var.naming[count.index]}"
    
    key_name = "${var.ec2_key_name}"
    vpc_security_group_ids = "${var.ec2_security_groups}"
    subnet_id = "${var.ec2_subnets[count.index]}"
    tags {
        Name = "${var.technology}-${var.stage}-${count.index + 1}${var.naming[count.index]}"
        terraform = "true"
        vertical = "${var.vertical}"
        platform = "${var.platform}"
        stage = "${var.stage}"
        technology = "${var.technology}"
    }
}