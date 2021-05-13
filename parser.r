parse <-function(df, distrito, coalicion){

    df_subset = subset(df, (df$Distrito == distrito & df$Coalicion == coalicion))
    html_string = ''

    for (x in 1:nrow(df_subset)){
        
        element = df_subset[x,]

        label = what_emoji(element$Posicion)
        new = paste0(emoji(label), element$Candidato,' (', element$Partido,')')
        html_string = paste0(html_string, new, " <br/> ")

    }
    return(html_string)
}

what_emoji <- function(label){
    label = as.factor(label)

    if (label == 'Adhiere'){
        emo = 'heavy_check_mark'
    } else if (label == 'Adhiere con reparos'){
        emo = 'ok'
    } else if (label == 'No adhiere'){
        emo = 'heavy_minus_sign'
    } else if (label == 'No expresa posición'){
        emo = 'woman_shrugging'
    } else {
        emo = 'question'
    }
        return(emo)

}