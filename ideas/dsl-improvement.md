if I look at the release.ash,   the process is not "natrual" enough,  we have to hide a lot of detail operations in separate scripts.
the sub process logic in prepare.ash and publish.ash, is too complicated for non tech person.

we need identify what's missing in ash language's abstraction of workflow, agent action,  a few points worthing thinking:
- lack of simple context data passing mechanism between steps
- lack of natural way of handling returns of exectuion steps,  it's using a lot stdout and post-process,  or rely agent steps to generate files, which introduces needs of error check.
- lack of Typing , this is related to the point above, because there is no typing, we have to do post-process 
- a lot manual error checks based on return code ,seems not nesseary, I think ash has a fail fast principle that just fail if steps ended with none 0


## something we need keep in mind
flow control is mandatory for complex/real processe, or most reasonable processes, directory based ochestration is handy and natrual, but it lack of flow control capability like, if , loop, fan out.

our goal is to make ash natrually represent the process. we are not trying to build a capable language. Given the focus of flow control. complex logic handling should still be handled by existing programming language(s), 