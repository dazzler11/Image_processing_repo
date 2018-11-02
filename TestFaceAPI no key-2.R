

Sys.setenv(kairos_id = "f5267bea")
Sys.setenv(kairos_key = "2fbe4aff872a47fce1b359436f92d6ef")
library(facerec)
#You only need to call facerec_init() once after loading the package.
facerec_init()

finn_image <- 'https://upload.wikimedia.org/wikipedia/en/2/2a/Finn-Force_Awakens_%282015%29.png'
#finn_image<-readImage("C:/Users/Baryons/Downloads/43080750_1945736615516340_5157512925082025984_n.jpg")1
finn_face <- detect(image = finn_image)
display(finn_image)

library(magick)
library(ggplot2)
library(scales)

finn_image %>% image_read() %>% image_ggplot() + 
  geom_rect(data = finn_face, 
            aes(xmin = top_left_x, xmax = top_left_x + width, 
                ymin = top_left_y, ymax = top_left_y + height),
            fill = NA, linetype = 'dashed', size = 2, color = 'red') +
  geom_label(data = finn_face,
             aes(x = chin_tip_x, y = chin_tip_y + 20, 
                 label = paste('Gender:', 
                               percent(face_gender_male_confidence),
                               'Male')), size = 6, color = '#377eb8') +
  geom_label(data = finn_face,
             aes(x = chin_tip_x, y = chin_tip_y + 60, 
                 label = paste('Ethnicity:', percent(face_black),
                               'Black')), size = 6, color = '#377eb8') +
  theme(legend.position="none")

###########################################
finn_image %>% image_read() %>% image_ggplot() + 
  geom_rect(data = finn_face, 
            aes(xmin = top_left_x , xmax =  top_left_x + width, 
                ymin = top_left_y, ymax = top_left_y + height, 
                color = factor(face_id)),
            fill = NA, linetype = 'dashed', size = 2) +
  geom_label(data = finn_face,
             aes(x = chin_tip_x, y = chin_tip_y + 15, 
                 label = face_gender_type,
                 color = factor(face_id)), size = 8) +
  theme(legend.position="none")

###########################################

sw_img<-readImage("C:/Users/Baryons/Downloads/43080750_1945736615516340_5157512925082025984_n.jpg")
sw_faces <- detect(image = sw_img)
display(sw_img)

https://www.google.co.in/url?sa=i&source=images&cd=&cad=rja&uact=8&ved=2ahUKEwji_bjjw7HeAhWFfX0KHeqYAZsQjRx6BAgBEAU&url=https%3A%2F%2Fin.linkedin.com%2Fin%2Fabhijit-sahoo-2219b2112&psig=AOvVaw3MAzmjGzglo3qhp4AfAjv_&ust=1541104494352855


sw_img <- "https://upload.wikimedia.org/wikipedia/en/8/82/Leiadeathstar.jpg"
sw_faces <- detect(sw_img)
sw_faces<-detect(sw_img)
sw_img %>% image_read() %>% image_ggplot() + 
  geom_rect(data = sw_faces, 
            aes(xmin = top_left_x , xmax =  top_left_x + width, 
                ymin = top_left_y, ymax = top_left_y + height, 
                color = factor(face_id)),
            fill = NA, linetype = 'dashed', size = 2) +
  geom_label(data = sw_faces,
             aes(x = chin_tip_x, y = chin_tip_y + 15, 
                 label = face_gender_type,
                 color = factor(face_id)), size = 8) +
  theme(legend.position="none")

#finn_face <- enroll(image = finn_image, 
 #                   subject_id = 'finn', gallery = 'starwars')
#finn_new <- 'https://upload.wikimedia.org/wikipedia/commons/b/b6/John_Boyega_by_Gage_Skidmore.jpg'
#finn_rec <- recognize(image = finn_new, gallery = 'starwars',
 #                     show_candidate_images = FALSE)
