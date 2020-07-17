import 'dart:core';

import 'dart:wasm';

import 'package:covid/country.dart';

class Regression {
  List<double> dayValues = [];
  List<double> quantityValues = [];
  double yIntercept;
  double slope;
  void linearRegressionCalc(List<double> xValues, List<double> yValues) {
    if (xValues.length != yValues.length) {
      throw new Exception("Input values should be with the same length.");
    }

    double xSum = 0;
    double ySum = 0;
    double xSumSquared = 0;
    double ySumSquared = 0;
    double codeviatesSum = 0;

    for (var i = 0; i < xValues.length; i++) {
      double x = xValues[i];
      double y = yValues[i];
      codeviatesSum += x * y;
      xSum += x;
      ySum += y;
      xSumSquared += x * x;
      ySumSquared += y * y;
    }

    int count = xValues.length;
    double xSS = xSumSquared - ((xSum * xSum) / count);
    double ySS = ySumSquared - ((ySum * ySum) / count);

    double numeratorR = (count * codeviatesSum) - (xSum * ySum);
    double denomR = (count * xSumSquared - (xSum * xSum)) *
        (count * ySumSquared - (ySum * ySum));
    double coS = codeviatesSum - ((xSum * ySum) / count);

    double xMean = xSum / count;
    double yMean = ySum / count;

    yIntercept = yMean - ((coS / xSS) * xMean);
    slope = coS / xSS;
  }

  int predictionTask(double month, double days) {
    linearRegressionCalc(dayValues, quantityValues);
    int inputObject = getDays(month, days).toInt();
    int predictedValue = ((slope * (inputObject)) + yIntercept).toInt();
    return predictedValue;
  }

  int getFutureDeaths(Country country) {
    dayValues.clear();
    quantityValues.clear();
    for (var data in country.getData()) {
      if (getDays(DateTime.now().month.toDouble(),
                  DateTime.now().day.toDouble()) -
              getDays(double.parse(data['date'].toString().split('-')[1]),
                  double.parse(data['date'].toString().split('-')[2])) <=
          7) {
        dayValues.add(getDays(
            double.parse(data['date'].toString().split('-')[1]),
            double.parse(data['date'].toString().split('-')[2])));
        quantityValues.add(double.parse(data['deaths'].toString()));
      }
    }
    return predictionTask(DateTime.now().add(Duration(days: 7)).month.toDouble(),DateTime.now().add(Duration(days: 7)).day.toDouble());
  }

  int getFutureHealed(Country country) {
    dayValues.clear();
    quantityValues.clear();
    for (var data in country.getData()) {
      if (getDays(DateTime.now().month.toDouble(),
                  DateTime.now().day.toDouble()) -
              getDays(double.parse(data['date'].toString().split('-')[1]),
                  double.parse(data['date'].toString().split('-')[2])) <=
          7) {
        dayValues.add(getDays(
            double.parse(data['date'].toString().split('-')[1]),
            double.parse(data['date'].toString().split('-')[2])));
        quantityValues.add(double.parse(data['recovered'].toString()));
      }
    }
    return predictionTask(DateTime.now().add(Duration(days: 7)).month.toDouble(),DateTime.now().add(Duration(days: 7)).day.toDouble());
  }

  int getFutureConfirmed(Country country) {
    dayValues.clear();
    quantityValues.clear();
    for (var data in country.getData()) {
      if (getDays(DateTime.now().month.toDouble(),
                  DateTime.now().day.toDouble()) -
              getDays(double.parse(data['date'].toString().split('-')[1]),
                  double.parse(data['date'].toString().split('-')[2])) <=
          7) {
        dayValues.add(getDays(
            double.parse(data['date'].toString().split('-')[1]),
            double.parse(data['date'].toString().split('-')[2])));
        quantityValues.add(double.parse(data['confirmed'].toString()));
      }
    }
    return predictionTask(DateTime.now().add(Duration(days: 7)).month.toDouble(),DateTime.now().add(Duration(days: 7)).day.toDouble());
  }

  double getDays(double month, double day) {
    double val = 0;

    for (int i = 1; i <= month; i++) {
      if (i % 2 == 1) {
        val += 31;
      } else {
        val += 30;
      }
    }
    for (int i = 0; i < day; i++) {
      val += 1;
    }
    return val;
  }
}
