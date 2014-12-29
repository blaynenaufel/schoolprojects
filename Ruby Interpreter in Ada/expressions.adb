package body Expressions is


   -- create_binary_expression with parameters of Arithmetic Operator--
   --expression 1, expression 2--
   --returns the expression result--

   function create_binary_expression (op: in Arithmetic_Operator;
                                      expr1, expr2: in Expression_Access)
                                      return Expression_Access is
      expr: Expression_Access;

      --assigns the new values to the parameters--

   begin
      expr := new Expression(BINARY_EXPR);
      expr.op := op;
      expr.expr1 := expr1;
      expr.expr2 := expr2;
      return expr;
   end create_binary_expression;


   -- create_var_expression and returns expression (don't know what  --
   -- var: in Id means--


   function create_var_expression (var: in Id) return Expression_Access is

      expr: Expression_Access;

      --assigns values to parameters--

   begin
      expr := new Expression (VAR_EXPR);
      expr.var := var;
      return expr;
   end create_var_expression;


   -- create_const_expression  and returns the expression--


   function create_const_expression (li: in Literal_Integer)
                                     return Expression_Access is
      --whats the purpose of expression access--
      expr: Expression_Access;

      --assigns values to parameters--

   begin
      expr := new Expression (CONST_EXPR);
      expr.li := li;
      return expr;
   end create_const_expression;


   -- evaluates the expression and returns the integer--
   --don't know what expr: Expression_Access is--


   function evaluate (expr: in Expression_Access) return Integer is

      result: Integer;

      --in this case, when the expression is a constant, a constant is returned--
      --when the expression is a variable, the variable is returned--
      --when the expression is a binary expression, the binary expression will be evaluated--
   begin
      case expr.expr_type is
         when CONST_EXPR =>
            result := get_value (expr.li);
         when VAR_EXPR =>
            result := get_value (expr.var);
         when BINARY_EXPR =>
            case expr.op is
               when ADD_OP =>
                  result := evaluate (expr.expr1) + evaluate (expr.expr2);
               when SUB_OP =>
                  result := evaluate (expr.expr1) - evaluate (expr.expr2);
               when MUL_OP =>
                  result := evaluate (expr.expr1) * evaluate (expr.expr2);
               when DIV_OP =>
                  result := evaluate (expr.expr1) / evaluate (expr.expr2);
            end case;
      end case;
      return result;

      --the result will be returned--

   end evaluate;

end Expressions;
