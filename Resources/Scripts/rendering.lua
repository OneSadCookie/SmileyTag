COLOR_PROPORTION = 0.5

renderQuad = function (red, green, blue,
                       left, bottom, width, height)
    glBegin(GL_QUADS)
        glColor3(COLOR_PROPORTION * red   + (1 - COLOR_PROPORTION),
                 COLOR_PROPORTION * green,
                 COLOR_PROPORTION * blue)
        glMultiTexCoord2ARB(GL_TEXTURE0_ARB, 0, 0)
        glMultiTexCoord2ARB(GL_TEXTURE1_ARB, 0, 0)
        glVertex2(left, bottom)
        
        glColor3(COLOR_PROPORTION * red,
                 COLOR_PROPORTION * green + (1 - COLOR_PROPORTION),
                 COLOR_PROPORTION * blue)
        glMultiTexCoord2ARB(GL_TEXTURE0_ARB, 1, 0)
        glMultiTexCoord2ARB(GL_TEXTURE1_ARB, 1, 0)
        glVertex2(left + width, bottom)
        
        glColor3(COLOR_PROPORTION * red,
                 COLOR_PROPORTION * green,
                 COLOR_PROPORTION * blue  + (1 - COLOR_PROPORTION))
        glMultiTexCoord2ARB(GL_TEXTURE0_ARB, 1, 1)
        glMultiTexCoord2ARB(GL_TEXTURE1_ARB, 1, 1)
        glVertex2(left + width, bottom + height)
        
        glColor3(COLOR_PROPORTION * red   + (1 - COLOR_PROPORTION),
                 COLOR_PROPORTION * green + (1 - COLOR_PROPORTION),
                 COLOR_PROPORTION * blue)
        glMultiTexCoord2ARB(GL_TEXTURE0_ARB, 0, 1)
        glMultiTexCoord2ARB(GL_TEXTURE1_ARB, 0, 1)
        glVertex2(left, bottom + height)
    glEnd()
end