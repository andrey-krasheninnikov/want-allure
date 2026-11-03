export const categories = ['foundation','inputs','navigation','data','feedback','effects','compositions'] as const;
export type Category = typeof categories[number];
export function categoryOf(value: string | null | undefined): Category { return categories.includes(value as Category) ? value as Category : 'foundation'; }
export const categoryCopy = {
  en: ['Foundation','Inputs','Navigation','Data','Feedback','Effects','Compositions'],
  ru: ['Основа','Ввод','Навигация','Данные','Обратная связь','Эффекты','Композиции'],
} as const;
export const categoryDescriptions = {
  en: ['Color, typography and identity. The decisions shared by every component.','Try focused, filled, disabled and invalid controls.','Move between views, reveal details and open contextual actions.','Explore records, sorting, pagination and file selection.','Clear status, progress and recovery actions.','Controlled motion, light and loading. Pause the scene at any time.','Components working together in compact product scenarios.'],
  ru: ['Цвет, типографика и айдентика — общие решения для всех компонентов.','Проверьте ввод, фокус, отключённые состояния и ошибки.','Переключайте представления, раскрывайте детали и открывайте контекстные действия.','Записи, сортировка, страницы и выбор файлов.','Понятные статусы, прогресс и действия для восстановления.','Управляемая анимация, свет и загрузка. Сцену можно поставить на паузу.','Компоненты вместе в компактных продуктовых сценариях.'],
} as const;
