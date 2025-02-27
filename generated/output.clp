(deftemplate class
   (slot name)
   (multislot attributes)
   (multislot operations))
(deftemplate attribute
   (slot id)
   (slot class-name)
   (slot name)
   (slot visibility)
   (slot type))
(deftemplate operation
   (slot id)
   (slot class-name)
   (slot name)
   (slot visibility)
   (slot type))
(deftemplate dependency
   (slot client)
   (slot supplier))
(deftemplate generalization
   (slot parent)
   (slot child))
(deftemplate directedAssociation
   (slot source)
   (slot target)
   (slot multiplicity1)
  (slot multiplicity2))
(deftemplate association
   (slot source)
   (slot target)
   (slot multiplicity1)
  (slot multiplicity2))
(deftemplate composition
   (slot whole)
   (slot part)
   (slot multiplicity)
   (slot isOrdered))
(deftemplate aggregation
   (slot whole)
   (slot part)
   (slot multiplicity))
(deffacts initial-facts
  (attribute (id attr1) (class-name f) (name a_Collection) (visibility private) (type "TreeSet<a>"))
  (attribute (id attr2) (class-name f) (name ss_Collection) (visibility private) (type "ArrayList<ss>"))
  (class (name f) (attributes attr1 attr2) (operations ))
  (attribute (id attr3) (class-name a) (name ss_List) (visibility private) (type "LinkedList<ss>"))
  (class (name a) (attributes attr3) (operations ))
  (class (name ss) (attributes ) (operations ))
  (class (name q) (attributes ) (operations ))
  (generalization (parent f) (child q))
  (association (source a) (target ss) (multiplicity1 None) (multiplicity2 None))
  (association (source f) (target q) (multiplicity1 None) (multiplicity2 None))
  (composition (whole "f") (part "a") (multiplicity "*") (isOrdered "false"))
  (composition (whole "f") (part "ss") (multiplicity "*") (isOrdered "false"))
  (aggregation (whole a) (part ss) (multiplicity None))
  (attribute (id "agga_ss") (class-name "a") (name "ssList") (visibility "private") (type "LinkedList<ss>"))
)

(defrule generate-java-code
   ?class <- (class (name ?class-name) (attributes $?attributes) (operations $?operations))
   (generalization (parent ?class-name) (child ?x))
   =>
   (printout t "// Java code for class " ?class-name crlf)
   (printout t "public class " ?class-name " extends " ?x " {" crlf)
   
   ;; Imprimir atributos
   (do-for-all-facts ((?attr attribute))
      (and
         (member$ (fact-slot-value ?attr id) $?attributes)
         (eq (fact-slot-value ?attr class-name) ?class-name))
      (bind ?visibility (fact-slot-value ?attr visibility))
      (bind ?type (fact-slot-value ?attr type))
      (bind ?name (fact-slot-value ?attr name))
      (printout t  "   " ?visibility " " ?type " " ?name ";" crlf))
   
   ;; Imprimir métodos
   (do-for-all-facts ((?op operation))
      (and
         (member$ (fact-slot-value ?op id) $?operations)
         (eq (fact-slot-value ?op class-name) ?class-name))
      (bind ?visibility (fact-slot-value ?op visibility))
      (bind ?type (fact-slot-value ?op type))
      (bind ?name (fact-slot-value ?op name))
      (printout t "   " ?visibility " " ?type " " ?name "()" " {" crlf
                "      // method body" crlf "   }" crlf))
   
   (printout t "}" crlf crlf)
)
                   
(defrule generate-java-code-no-inheritance
   ?class <- (class (name ?class-name) (attributes $?attributes) (operations $?operations))
   (not (generalization (parent ?class-name)))
    =>
   (printout t "// Java code for class " ?class-name crlf)
   (printout t "public class " ?class-name " {" crlf)
   
   ;; Imprimir atributos
   (do-for-all-facts ((?attr attribute))
      (and
         (member$ (fact-slot-value ?attr id) $?attributes)
         (eq (fact-slot-value ?attr class-name) ?class-name))
      (bind ?visibility (fact-slot-value ?attr visibility))
      (bind ?type (fact-slot-value ?attr type))
      (bind ?name (fact-slot-value ?attr name))
      (printout t  "   " ?visibility " " ?type " " ?name ";" crlf))
   
   ;; Imprimir métodos
   (do-for-all-facts ((?op operation))
      (and
         (member$ (fact-slot-value ?op id) $?operations)
         (eq (fact-slot-value ?op class-name) ?class-name))
      (bind ?visibility (fact-slot-value ?op visibility))
      (bind ?type (fact-slot-value ?op type))
      (bind ?name (fact-slot-value ?op name))
      (printout t "   " ?visibility " " ?type " " ?name "()" " {" crlf
                "      // method body" crlf "   }" crlf))
   
   (printout t "}" crlf crlf)
)
