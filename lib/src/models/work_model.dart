class WorkModel {
  WorkModel({int? truckCount, int? orderCount, int? jobCount}) {
    this.trucksCount = truckCount ?? 0; 
    this.ordersCount = orderCount ?? 0;
    this.jobsCount = jobCount ?? 0;
  }
  int trucksCount = 0;
  int ordersCount = 0;
  int jobsCount = 0;

  WorkModel.from(Map map) {
    trucksCount = map['trucksCount'] ?? 0;
    ordersCount = map['ordersCount'] ?? 0;
    jobsCount = map['jobsCount'] ?? 0;
  }
}
