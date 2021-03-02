```
def genomic_location_to_hgvsg(mutation_row):
    chro = mutation_row["Chromosome"]
    start = mutation_row["Start_Position"]
    end = mutation_row["End_Position"]
    ref = mutation_row["Reference_Allele"]
    var = mutation_row["Alternate_Allele"]
    hgvs = ""
    if start < 1:
    #             // cannot convert invalid locations
    #             // Ensembl uses a one-based coordinate system
        hgvs = None
    elif ref == "-" or len(ref) == 0 or ref == "NA" or "--" in ref:
    #         /*
    #         Process Insertion
    #         Example insertion: 17 36002277 36002278 - A
    #         Example output: 17:g.36002277_36002278insA
    #         */

        hgvs = chro + ":g." + str(start) + "_" + str(start + 1) + "ins" + var

    elif var == "-" or len(var) == 0 or var == "NA" or "--" in var:
        if len(ref) == 1:
    #             /*
    #             Process Deletion (single positon)
    #             Example deletion: 13 32914438 32914438 T -
    #             Example output:   13:g.32914438del
    #             */
            hgvs = chro + ":g." + str(start) + "del"
            
        else:
    #             /*
    #             Process Deletion (multiple postion)
    #             Example deletion: 1 206811015 206811016  AC -
    #             Example output:   1:g.206811015_206811016del
    #             */
            hgvs = chro + ":g." + str(start) + "_" + str(end) + "del"
    elif len(ref) > 1 and len(var) >= 1:
    #         /*
    #         Process ONP (multiple deletion insertion)
    #         Example INDEL   : 2 216809708 216809709 CA T
    #         Example output: 2:g.216809708_216809709delinsT
    #         */
        hgvs = chro + ":g." + str(start) + "_" + str(end) + "delins" + var
    elif len(ref) == 1 and len(var) > 1:
    #         /*
    #         Process ONP (single deletion insertion)
    #         Example INDEL   : 17 7579363 7579363 A TTT
    #         Example output: 17:g.7579363delinsTTT
    #         */
        hgvs = chro + ":g." + str(start) + "delins" + var
    else:
    #         /*
    #         Process SNV
    #         Example SNP   : 2 216809708 216809708 C T
    #         Example output: 2:g.216809708C>T
    #         */
        hgvs = chro + ":g." + str(start) + ref + ">" + var
    return hgvs

def generate_index(mutation_row, mutation_status):
    hgvsg = genomic_location_to_hgvsg(mutation_row)
    if hgvsg is not None:
        if mutation_status == "somatic":
            return "s_" + hgvsg
        else:
            return "g_" + hgvsg
    return None

```
