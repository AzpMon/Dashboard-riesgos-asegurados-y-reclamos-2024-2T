import pandas as pd 

def separar_excel(nombre_excel):
    # Se lee el archivo principal considerando las hojas
    excel = pd.read_excel(nombre_excel, sheet_name=None) 
    
    # Se guarda cada hoja como un archivo csv
    for nombre, df in excel.items():
        # Añadir una columna con el nombre de la hoja
        df['nombre_hoja'] = nombre  # Añadimos la columna con el nombre de la hoja
        df.to_csv(f'{nombre}.csv', index=False, encoding='utf-8')

if __name__ == '__main__':
    separar_excel('Asegurados y Reclamaciones 2024_2.xlsx')
