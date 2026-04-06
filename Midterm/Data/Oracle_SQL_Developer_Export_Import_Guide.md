# Oracle SQL Developer: How to Export and Import .sql Files

This document provides a step-by-step guide on how to export your database tables and data into a `.sql` file, and how to import them back into Oracle SQL Developer.

## 1. How to EXPORT a `.sql` file (Exporting a Table & Data)

If you have a table (like `IMDB_RANKING`) and you want to save its structure and data to a `.sql` script:

1. **Open Oracle SQL Developer** and **Connect** to your database.
2. In the **Connections** panel on the left, expand your connection, and then expand the **Tables** folder.
3. **Right-click** on the table you want to export (e.g., `IMDB_RANKING` or `AI_JOB_TRENDS`).
4. Select **Export...** from the context menu.
5. In the Export Wizard window that pops up, configure the following:
   * **Export DDL**: Check this box if you want to include the `CREATE TABLE` statement. (Usually, you want this checked).
   * **Export Data**: Check this box to include the `INSERT` statements for your data.
   * **Format**: Make sure this is set to **insert**.
   * **Save As**: Choose **Single File** to export everything into one script.
   * **File**: Click the **Browse** button to choose where to save the file on your computer (e.g., `C:\Users\Tesla Laptops\Downloads\Data\my_export.sql`).
6. Click **Next**, review the summary, and then click **Finish**. 
7. Oracle SQL Developer will take a moment to generate the file. Once done, your table and data are securely backed up in a `.sql` file!

---

## 2. How to IMPORT a `.sql` file (Running a Script)

If you have a `.sql` file containing `CREATE TABLE` and `INSERT` statements (this functions as your import), here is how you run it to load the data:

1. **Open Oracle SQL Developer** and **Connect** to your target database.
2. Turn off substitution prompting (if your text contains `&` symbols):
   * This is important if your data contains text like "Pride & Prejudice" or "R&D". 
   * It is best to have `SET DEFINE OFF;` at the very top of your `.sql` script. If it isn't there, you can type it manually at the top.
3. **Open your `.sql` file**:
   * Go to **File > Open...** in the top menu (or press `Ctrl` + `O`).
   * Navigate to the location of your `.sql` file and open it.
4. **Select the correct Connection**:
   * Look at the top right of the SQL Worksheet window. Ensure the dropdown menu has your correct database connection selected.
5. **Run the Script**:
   * Click the **Run Script** button on the worksheet toolbar (it looks like a document with a small green play button, usually the second button from the left).
   * Alternatively, you can press **`F5`** on your keyboard.
6. The script will execute. You can watch the **Script Output** panel at the bottom to see it progress. 
7. Once you see "Commit complete" and the process finishes, **refresh your Tables folder** on the left panel to see your newly imported table and its data.
