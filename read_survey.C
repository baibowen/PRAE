#include <iostream>
#include <fstream>
#include <string>

//void read_survey(string beamline){
void read_survey(){
  string beamline("prorad");
  //string beamline("radiobiology");

  ifstream input("survey_" + beamline + "_madx.dat");
  ofstream output("survey_" + beamline + "_gnuplot.dat");

  string buff;

  double s,x,y,z;

  for (int i = 0; i <8 ; i++){ // skip 
    getline(input,buff);
  }
  while (input >> buff >> s>>x>>y>>z){
    output << s << "\t" << x << "\t"<<y<< "\t" << z << "\n";
  }

  output.close();
  input.close();

  system("./plot_survey.gnu");

}
