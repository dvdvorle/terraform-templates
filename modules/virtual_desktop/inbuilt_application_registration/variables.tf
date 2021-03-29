variable "name" {
  description = "The name of the application registration"
  type = string
}

variable "friendly_name" {
  description = "The name that is shown in the WVD portal"
  type = string
}

variable "resource_group_name" {
  description = "Name of the resource group this application should be deployed into"
  type = string
}

variable "application_group_name" {
  description = "The name of the application group this application should be put in"
  type = string
}

variable "file_path" {
  description = "The file path where the application resides"
  type = string
 
  validation {
    condition = length(regexall("[*?\"<>|/]", var.file_path)) == 0
    error_message = "Enter a Windows or universal app rooted absolute path, e.g. \"C:\\app.exe\" or \"shell:AppsFolder\\appname!App\". File names can't contain any of the following characters ': * ? \" < > | /'."
  }
}

variable "icon_path" {
  description = "The file path where the icon of the application can be retrieved"
  type = string

  validation {
    condition = length(regexall("[*?\"<>|/]", var.icon_path)) == 0
    error_message = "Enter a Windows or universal app rooted absolute path, e.g. \"C:\\app.exe\" or \"shell:AppsFolder\\appname!App\". File names can't contain any of the following characters ': * ? \" < > | /'."
  }
}

variable "icon_index" {
  description = "The index of the icon within the icon_path"
  type = number
}

variable "args" {
  description = "The command line arguments that should be passed to the application"
  type = string
  default = ""
}

