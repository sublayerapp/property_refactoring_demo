class RefactoringPlanGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :list_of_named_strings,
    name: "refactoring_tasks",
    description: "List of refactoring tasks",
    item_name: "task",
    attributes: [
      { name: "title", description: "The title to give this task" },
      { name: "description", description: "Detailed Description of the refactoring task" },
      { name: "priority", description: "Priority of the task (high, medium, low)" },
      { name: "complexity", description: "Estimated complexity (high, medium, low)" }
    ]

  def initialize(code:,code_analysis:)
    @code = code
    @code_analysis = code_analysis
  end

  def prompt
    <<-PROMPT
    Based on the following code analysis:

    #{@code_analysis}

    Of the following code:
    #{@code}

    Generate a list of extremely specific refactoring tasks. For each task, provide:
    1. A detailed description of the refactoring task
    2. The priority of the task (high, medium, low)
    3. The estimated complexity (high, medium, low)

    Focus on tasks that will help decouple the Company class and improve the overall structure of the code.
    PROMPT
  end
end
