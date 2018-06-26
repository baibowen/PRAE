Octave {
    format long;
    % read in some useful functions
    scriptdir="$scriptdir/";
    source([scriptdir,"octave_beam_creation.m"]);
    source([scriptdir,"octave_beam_statistics.m"]);
    source([scriptdir,"octave_beam_statistics_output.m"]);
    source([scriptdir,"octave_beamline_errors.m"]);
    source([scriptdir,"octave_cavitywakesetup.m"]);
    source([scriptdir,"octave_correction_algorithms.m"]);
}
