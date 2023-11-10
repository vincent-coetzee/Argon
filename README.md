# Argon
The latest incarnation of the compiler and IDE for the Argon language.

Note: There are two dylibs missing from the repo, i.e. the repo references but does not have copies of the two LLVM libraries, 
libLLVM.dylib and libLLVM-C.dylib. These two shared libraries belong to the LLVM 16 installation and are necessary for the correct
functioning of the Argon compiler. You should be able to obtain these two dylibs from the LLVM repository.

Argon is an object oriented programming language which does things in a slightly different way to other OO languages. It most closely
resembles Dylan in how it functions. Argon allows for multiple inheritance of state ONLY. "ONLY" means that behavior is not attached 
to classes as in most OO languages, instead, Argon offers multimethods where the methods selected for execution depend entirely on
the types of parameters being passed to the method. The compiler chooses the method that is most specific for the types of the parameters. 
Given this functionality it is not necessary for methods to be attached to classes. Classes and their instances, in this language 
define just state not behaviour.

![Sample Module](https://github.com/vincent-coetzee/Argon/SampleModule.png "Sample Module")

Sample Argon Module

```argon
MODULE Entities
    {
    ABSTRACT CLASS Named :: Object
      {
      SLOT name :: String = ""
      }

    ABSTRACT CLASS Registered :: Object
      {
      SLOT registrationNumber :: String = ""
      }

    ENUMERATION EntityType
        {
        #abstract
        #none
        #entity
        #individual
        #corporate
        }

    TYPE GroupType IS EntityType

    CLASS Entity :: Named,Registered
       {
       READ SLOT entityType = EntityType->none
       READWRITE SLOT registrationDate = @(1900,01,01)
       READWRITE SLOT wasTouched = FALSE
       }
       
    CLASS Individual :: Entity
      {
      READ SLOT firstName = ""
      WRITE SLOT lastName = ""
      WRAPPER SLOT dateOfBirth 
        { 
        SELF->registrationDate 
        } 
      VIRTUAL SLOT age :: Integer
        {
        READ
          {
          @(TODAY) - SELF->dateOfBirth
          }
        WRITE(newValue)
          {
          SELF->dateOfBirth = @(TODAY) - newValue
          }
        }
      }

    METHOD print(-entity::Entity)
      {
      print("ENTITY \\entity->entityType")
      entity->entityType = #entity
      }

    METHOD print(-individual::Individual)
      {
      print("INDIVIDUAL \\individual->entityType")
      individual->wasTouched = TRUE
      }

    METHOD print(entityType::EntityType)
        {
        print("ENTITY-TYPE \\entityType")
        }
    }
```
