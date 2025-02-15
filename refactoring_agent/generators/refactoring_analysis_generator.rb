class RefactoringAnalysisGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :list_of_named_strings,
    name: "class_coupling_analysis",
    description: "Analysis of a class with specific instances of tight coupling between models.",
    item_name: "coupling_instance",
    attributes: [
      { name: "offending code", description: "Code snippet that shows the tight coupling between the given class and another class" },
      { name: "reasoning", description: "Explanation of why the coupling is considered tight" },
      { name: "suggested_solution", description: "Suggested solution to decouple the classes" }
    ]

  def initialize(code:)
    @code = code
  end

  def prompt
    <<~PROMPT
      Analyze the following Ruby on Rails model class:

      #{@code}
      The class is a good example of an anti-pattern known as "god class" and we are trying to refactor it.

      But the first step is to categorize all the places where this class is tightly coupled with other classes.

      Provide a list of instances where this class is tightly coupled with other classes. For each instance, provide:
      1. The offending code snippet that shows the tight coupling between this class and another class.
      2. An explanation of why the coupling is considered tight.
      3. A suggested solution to decouple the classes.
    PROMPT
  end
end

