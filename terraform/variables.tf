variable "yc_token" {
  description = "Token for Yandex Cloud auth"
  type        = string
  sensitive = true
}

variable "cloud_id" {
  description = "Yandex Cloud cloud_id"
  type        = string
  sensitive = false
  default = ""
}

variable "folder_id" {
  description = "Yandex Cloud folder_id"
  type        = string
  sensitive = false
  default = ""
}

variable "image_id_ubuntu" {
  description = "Yandex Cloud image_id"
  type        = string
  sensitive = false
  default = "fd87uq4tagjupcnm376a"
}

variable "image_id_centos" {
  description = "Yandex Cloud image_id"
  type        = string
  sensitive = false
  default = "fd878e3sgmosqaquvef5"
}
