locals {
    rsa = aws_key_pair.demo_key.key_name
    instance_type = "t2.micro"
    target_group_id = aws_lb_target_group.main.id
    launch_template_id = aws_launch_template.template.id
    sg_id = data.terraform_remote_state.network.outputs.sg_id
    vpc_id = data.terraform_remote_state.network.outputs.vpc_new_id
    sub_ids = data.terraform_remote_state.network.outputs.sub_ids

}