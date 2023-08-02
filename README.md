# Argon
The latest incarnation of the compiler and IDE for the Argon language.

Note: There are two dylibs missing from the repo, i.e. the repo references but does not have copies of the two LLVM libraries, 
libLLVM.dylib and libLLVM-C.dylib. These two shared libraries belong to the LLVM 16 installation and are necessary to the correct
functioning of the Argon compiler. You should be able to obtain these two dylibs from the LLVM repository.

Argon is an object oriented programming language which does things in a slightly different way to other OO languages. It most closely
resembles Dylan in how it functions. Argon allows for multiple inheritance of state ONLY. "ONLY" means that behavior is not attached 
to classes as in most OO languages, instead, Argon offers multimethods where the methods selected for execution depend enttirely on
the types of parameters being passed to the method. The compiler chooses the method that is most specific for the types of the parameters. 
Given this functionality it is not necessary for methods to be attached to classes, classes and their instances, in this situation 
define just state not behaviour.
