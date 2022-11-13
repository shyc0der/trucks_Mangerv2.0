// ignore_for_file: file_names

class ResponseModel {
  ResponseModel(this.status, this.body);
  ResponseType status;
  dynamic body;
}


enum ResponseType{
  success, warning, error
}