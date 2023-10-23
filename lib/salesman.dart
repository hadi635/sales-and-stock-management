import 'package:salesandstockmanagement_app1/person.dart';

class salesman extends person{
double ratecomission;
double totalsales;

salesman(int id, String name, String nbtelephone, this.ratecomission, this.totalsales)
      : super(id, name, nbtelephone);

}