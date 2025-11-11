# ✅ Checklist del Proyecto Final  
### Máster ABAP Cloud II – Sistema de Gestión de Incidentes  

---

## 1. Alcance General

- [ ] Aplicación basada en **ABAP RAP with DRAFT**.  
- [ ] Implementar operaciones **CRUD** completas.  
- [ ] Incluir validaciones de negocio en Behavior Definitions.  
- [ ] Optimizar rendimiento con buenas prácticas de ABAP Cloud.  
- [ ] Desarrollar UI en **Fiori Elements (OData V4)**.  
- [ ] Formularios y listas para gestión de incidentes.  
- [ ] Manejo de mensajes de validación y errores.  

---

## 2. Estructura de Datos (Diccionario de Datos)

- [ ] Crear **elementos de datos y dominios** específicos.  
- [ ] Crear tablas base:
  - [ ] `ZDT_INCT_USER` – Incidencias.  
  - [ ] `ZDT_INCT_H_USER` – Historial.  
  - [ ] `ZDT_STATUS_USER` – Estados.  
  - [ ] `ZDT_PRIORITY_USER` – Prioridades.  
- [ ] Configurar claves primarias y foráneas.  
- [ ] Utilizar **UUID** como clave primaria.  
- [ ] Respetar nomenclatura con sufijo del usuario SAP.  

---

## 3. Diseño de Tablas y Relaciones

- [ ] **ZDT_INCT_USER:** Definir campos `INC_UUID`, `INCIDENT_ID`, `TITLE`, `DESCRIPTION`, `STATUS`, `PRIORITY`, `CREATION_DATE`, etc.  
- [ ] **ZDT_INCT_H_USER:** Definir campos `HIS_UUID`, `INC_UUID`, `PREVIOUS_STATUS`, `NEW_STATUS`, `TEXT`, etc.  
- [ ] **ZDT_STATUS_USER:** Incluir códigos `OP`, `IP`, `PE`, `CO`, `CL`, `CN`.  
- [ ] **ZDT_PRIORITY_USER:** Incluir códigos `H`, `M`, `L`.  
- [ ] Definir relaciones:
  - [ ] `ZDT_INCT_H_USER` → `ZDT_INCT_USER` (`INC_UUID`).  
  - [ ] `ZDT_INCT_USER` → `ZDT_STATUS_USER` (`STATUS`).  
  - [ ] `ZDT_INCT_USER` → `ZDT_PRIORITY_USER` (`PRIORITY`).  
- [ ] Crear dominios para `STATUS` y `PRIORITY` con valores fijos.  

---

## 4. Modelado RAP

- [ ] Entidad raíz: **Incidentes** con composición `[0..*]` a **Historial**.  
- [ ] Guardado adicional que registre cambios de estado en `ZDT_INCT_H_USER`.  
- [ ] Crear entidades de consumo (proyección):
  - [ ] `ZC_DT_INCT_USER` (transaccional).  
  - [ ] `ZC_DT_INCT_H_USER` (historial).  
- [ ] Configurar redireccionamiento entre entidades de consumo.  

---

## 5. Metadata Extensions

### Entidad: Incidentes
- [ ] Orden ascendente por `INCIDENT_ID`.  
- [ ] Título de encabezado: **Incident**.  
- [ ] Ocultar columnas de auditoría, `inc_uuid` y `title` (solo en filtros).  
- [ ] Usar `@UI.facet` con `#IDENTIFICATION_REFERENCE`.  
- [ ] Definir acción para cambio de estado (`@UI.lineItem`, `@UI.identification`).  
- [ ] Configurar importancia de campos:
  - [ ] `UUID` → #HIGH  
  - [ ] `ID` → #MEDIUM  
  - [ ] Otros → #LOW  

### Entidad: Historial
- [ ] Orden ascendente por `HIS_ID`.  
- [ ] Título de encabezado: **History**.  
- [ ] Ocultar columnas de auditoría, `his_uuid` y `inc_uuid`.  
- [ ] Deshabilitar creación (`@UI.createHidden: true`).  
- [ ] Usar `@UI.facet` con `#LINEITEM_REFERENCE`.  
- [ ] Configurar importancia de campos:
  - [ ] `UUID` → #HIGH  
  - [ ] `ID` → #MEDIUM  
  - [ ] Otros → #LOW  

---

## 6. Behavior Definition

### Entidad: Incidentes
- [ ] Habilitar botones CRUD.  
- [ ] Asociar entidad hija (historial) con `with draft`.  
- [ ] Campos de solo lectura: `inc_uuid`, `incident_id`, `status`, `creation_date`, auditoría.  
- [ ] Autoincremento de `incident_id`.  
- [ ] Campos obligatorios: `title`, `description`, `priority`.  
- [ ] Definir acción “Cambiar Estado” con campos `nuevo_status` y `observacion`.  
- [ ] Determinación `on save`: insertar historial inicial (`OP`, “First Incident”).  
- [ ] Determinación `on modify`: precargar `incident_id`, `creation_date`, `status`.  
- [ ] Activar acciones Draft: Activate, Discard, Edit, Resume, Prepare.  

### Entidad: Historial
- [ ] Habilitar operaciones update/delete.  
- [ ] Asociar con entidad padre.  
- [ ] Campos de solo lectura (`his_uuid`, `inc_uuid`, auditoría).  
- [ ] Autoincremento de `his_uuid`.  

---

## 7. Business Services

- [ ] Crear **Service Definition** exponiendo `ZC_DT_INCT_USER` y `ZC_DT_INCT_H_USER`.  
- [ ] Crear **Service Binding** tipo **OData V4 - UI**.  
- [ ] Validar preview funcional desde el navegador.  

---

## 8. Acciones UI

- [ ] Crear botón **Cambiar Estado** con pop-up.  
- [ ] Solicitar nuevo estado y observación.  
- [ ] Deshabilitar la acción durante creación de registros nuevos.  

---

## 9. Validaciones Funcionales

- [ ] Campos obligatorios: `TITLE`, `DESCRIPTION`, `PRIORITY`, `STATUS`, `CREATION_DATE`.  
- [ ] No eliminar valores obligatorios al actualizar.  
- [ ] No cambiar a `CO` o `CL` desde `PE`.  
- [ ] No permitir cambios desde `CN`, `CO`, `CL`.  
- [ ] Validar que `CHANGE_DATE ≥ CREATION_DATE`.  
- [ ] No permitir fechas futuras.  
- [ ] Si `STATUS = IP`, debe existir `RESPONSABLE`.  
- [ ] Solo responsable o administrador pueden cambiar estado.  

---

## 10. Pruebas

- [ ] Probar operaciones CRUD desde UI Fiori.  
- [ ] Validar mensajes de error y restricciones.  
- [ ] Verificar creación automática en historial.  

---

## 11. Entregables

- [ ] Código fuente ABAP Cloud documentado.  
- [ ] Documentación técnica (tablas, lógica, flujos).  
- [ ] Repositorio público GitHub con **abapGit**.  
- [ ] Verificar ejecución completa y correcta desde navegador.  

---

📘 **Repositorio de referencia:**  
[https://github.com/Logali-Group/996-01-Project-ACII](https://github.com/Logali-Group/996-01-Project-ACII)

