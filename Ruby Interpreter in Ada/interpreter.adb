with Parsers, Programs, Lexical_Analyzers, Ada.Text_IO, Ada.Exceptions;
use Parsers, Programs, Lexical_analyzers, Ada.Text_IO, Ada.Exceptions;

procedure Interpreter is

   p: Parser;
   prog: Program;

begin
   --creates parser--
   p := create_parser ("test1");
   parse (p, prog);
   --executes program--
   execute (prog);
exception
      --for any exceptions or errors(errors in lexical analyzer)--
   when e: lexical_exception =>
      put_line (exception_information (e));
      --for any exceptions or errors(errors in parser)--
   when e: parser_exception =>
      put_line (exception_information (e));
   when others =>
      put_line ("unknown error - terminating");
end Interpreter;
