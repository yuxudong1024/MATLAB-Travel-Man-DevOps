function plan = buildfile
import matlab.buildtool.tasks.CodeIssuesTask
import matlab.buildtool.tasks.TestTask
import matlab.buildtool.io.FileCollection

% Create a plan from task functions
plan = buildplan(localfunctions);

% Add a task to identify code issues
plan("check") = CodeIssuesTask;

% Add a task to run tests
plan("test") = TestTask(SourceFiles=FileCollection.fromPaths("source"), ...
    TestResults="test-reports/junit.xml", ...
    CodeCoverageResults="code-coverage/cobertura-coverage.xml");

% Make the "archive" task the default task in the plan
plan.DefaultTasks = "test";

end

function buildCtfTask(~)
    % Build CTF
    mpsResults = compiler.build.productionServerArchive(fullfile(currentProject().RootFolder, ...
        "source","shortest_path.m"));
    disp(mpsResults.Files{1});
    [status,message] = copyfile(mpsResults.Files{1}, "\\mathworks\inside\labs\matlab\mps");
    disp(status);
    disp(message);
end