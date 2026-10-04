locals {
  students = [
    for i in range(var.student_count) :
    format("student%02d", i + 1)
  ]
}