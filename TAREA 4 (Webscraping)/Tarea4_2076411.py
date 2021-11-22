import requests
from bs4 import BeautifulSoup


URL = "https://realpython.github.io/fake-jobs/"
page = requests.get(URL)

soup = BeautifulSoup(page.content, "html.parser")
results = soup.find(id="ResultsContainer")

job_element = results.find_all("div", class_="card-content")

python_jobs = results.find_all("h2", string=lambda text: "python" in text.lower())


python_jobs_elements = [ h2_element.parent.parent.parent for h2_element in python_jobs ]

for job_element in python_jobs_elements:
    title_element = job_element.find("h2", class_="title")
    company_element = job_element.find("h3", class_="company")
    location_element = job_element.find("p", class_="location")

    link_url = job_element.find_all("a")[1]["href"]
    print(company_element.text.strip())
    print(location_element.text.strip())
    print(title_element.text.strip())

    print(f"Apply Here: {link_url}\n")
    print()

    fo = open("TAREALPC.csv", "a")
    fo.write(company_element.text.strip()+',\n')
    fo.write(location_element.text.strip()+',\n')
    fo.write(title_element.text.strip()+',\n')
    fo.write(f"Apply Here: {link_url}\n")
    fo.write('-----------------------------\n')
    fo.close()
