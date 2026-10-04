locals {
  students = {
    for i in range(var.student_count) :
    format("student%02d", i + 1) => format("tf-student%02d", i + 1)
  }

  name_prefix = "terraform-training"
}


