#!/usr/bin/mawk

# en linea de comandos: -v ultimo=`cat `

# BEGIN { print("Hola") }

{
    split($0,cs_aux,"_");
    split(cs_aux[3],cs_aux_3,".")
    # cs[cs_aux[2]] = cs_aux_3[1]
    if (cs_aux_3[1] > ultimo) {
	print($0)
    }
}

# END {
# for (ini in cs) {
#     printf("%s : cs[%s] = %s\n", ultimo, ini, cs[ini])
# }
# print("Adios")
# }

