module ORTools::Sat
  # All types that can be converted to a `LinearExpression` with #to_lexpr
  alias Expressible = (Int32|Int64|IntVar|LinearExpression)
end
