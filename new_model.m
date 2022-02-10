%%%%%%%%%%%%%%%%%%%
% Author: Lige
% Date: 2022.2.10
% Description:
%    The shortcut will create a new simulink file generating embedded C code.
%%%%%%%%%%%%%%%%%%%
%%
% Create a new file
open_system(new_system)
%%
% configurate simulation parameters
% configure solver
set_param(bdroot,'SolverType','Fixed-step')
set_param(bdroot,'Solver','FixedStepDiscrete')
% configurate TLC and build
set_param(bdroot,'GenCodeOnly','on')
set_param(bdroot,'SystemTargetFile','ert.tlc')
% configurate report
set_param(bdroot,'GenerateReport','on')
set_param(bdroot,'LaunchReport','on')
% configurate data record
set_param(bdroot,'SaveTime','off')
set_param(bdroot,'SaveOutput','off')
set_param(bdroot,'SignalLogging','off')
set_param(bdroot,'DSMLogging','off')
set_param(bdroot,'ReturnWorkspaceOutputs','off')
