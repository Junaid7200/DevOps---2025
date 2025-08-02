from django.db import models

class Student(models.Model):
    name = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    age = models.IntegerField()
    grade = models.CharField(max_length=2)
    
    def __str__(self):
        return self.name
    
    class Meta:
        ordering = ['name']