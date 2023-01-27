
//RSA KEY
resource "aws_key_pair" "demo_key" { 
  key_name = "demo_key" 
  public_key = file("~/.ssh/id_rsa.pub") 
} 

//LISTENER
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
  depends_on = [
    aws_lb.test,
    aws_lb_target_group.main
  ]
}

//TARGET GROUP
resource "aws_lb_target_group" "main" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id
}
