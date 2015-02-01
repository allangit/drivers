import pygame
import serial
import Tkinter
import time

pygame.init()
black=(0,0,0)
white=(255,255,255)
red=(255,0,0)
lime=(0,255,0)
display_width=800
display_height=600

car_width=70
gameDisplay=pygame.display.set_mode((display_width,display_height))
pygame.display.set_caption(" a Bit Racer")
clock=pygame.time.Clock()
Cu=pygame.image.load("car.png")


def Car(x,y):

    gameDisplay.blit(Cu,(x,y))
def text_objects(text,font,color):

    textSurface=font.render(text,True,black)
    return textSurface,textSurface.get_rect()

def crash():

    message_display("YOU CRASH")


def message_display(text):
    largeText=pygame.font.Font("freesansbold.ttf",125)
    TexSurf,TextRect=text_objects(text,largeText,black)
    TextRect.center=((display_width/2),(display_height/2))
    gameDisplay.blit(TexSurf,TextRect)

    pygame.display.update()
    time.sleep(2)
    
    game_loop()

    
def game_loop():
    x=(display_width * 0.2)
    y=(display_height * 0.6)
    x_change=0
    game_over= False
    while not game_over:

        for event in pygame.event.get():
            if event.type==pygame.QUIT:
                game_over=True

            if event.type==pygame.KEYDOWN:
                if event.key==pygame.K_LEFT:
                    x_change=-5
                elif event.key==pygame.K_RIGHT:
                    x_change= 5

            if event.type==pygame.KEYUP:
                if event.key==pygame.K_LEFT or event.key==pygame.K_RIGHT:
                    x_change=0

        x+=x_change

        gameDisplay.fill(lime)
        Car(x,y)
        if x > display_width-car_width or x < 0:
            crash()
            
        pygame.display.update()
        clock.tick(60)


game_loop()
pygame.quit()
quit()
