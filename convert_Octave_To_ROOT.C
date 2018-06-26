void convert_Octave_To_ROOT(TString infileName){

  std::ifstream ifile(infileName,ios_base::in);
  std::string line;

  TString outfileName(infileName);
  outfileName.ReplaceAll(".dat",".root");

  double e,x,y,z,xp,yp;

  TFile * fileROOT  = new TFile(outfileName, "RECREATE");
  TTree tree("tree","A tree with particle information");

  tree.Branch("x",&x,"x/D");
  tree.Branch("y",&y,"y/D");
  tree.Branch("z",&z,"z/D");
  tree.Branch("xp",&xp,"xp/D");
  tree.Branch("yp",&yp,"yp/D");
  tree.Branch("e",&e,"e/D");

  while(getline(ifile,line)){
    if (!line.length() || line[0] == '#')
      continue;
    std::istringstream iss(line);
    iss>>e>>x>>y>>z>>xp>>yp;

    tree.Fill();
  }

  ifile.close();

  tree.Write();

  fileROOT->Close();
  delete fileROOT;

}
