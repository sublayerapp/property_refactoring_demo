class RefactoringStepsGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :list_of_named_strings,
    name: "refactoring_steps",
    description: "Detailed instructions on how to perform the given refactoring task",
    item_name: "step",
    attributes: [
      { name: "action_to_perform", description: "Either 'modify_file' or 'create_file'" },
      { name: "file_path", description: "Path to the file to modify or create" },
      { name: "description", description: "Detailed description of the change to make" },
      { name: "code", description: "The updated or new code for the file" }
    ]

    def initialize(code:, refactoring_step:, refactoring_steps:)
      @code = code
      @refactoring_step = refactoring_step
      @refactoring_steps = refactoring_steps
    end

    def prompt
      <<-PROMPT
      You are an expert ruby on rails programming.

      You are working to perform a major refactoring of a ruby on rails app one by one. All of the refactorings we'll be doing are:
      #{@refactoring_steps}

      The one we are currently working on is:
      #{@refactoring_step}

      Of the following code of app/models/property.rb:
      #{@code}

      Generate a list of detailed instructions on how to perform the given refactoring task. For each step, provide:
      1. The action to perform (either 'modify_file' or 'create_file')
      2. The file path to the file to modify or create
      3. A detailed description of the change to make
      4. The updated or new code for the file
      PROMPT
    end
end
