import React, { useState, useEffect } from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import MaterialTable from 'material-table';

import TablePagination from '@material-ui/core/TablePagination';
import Input from '@material-ui/core/Input';
import Button from '@material-ui/core/Button';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';

const Links = () => {
  const [links, setLinks] = useState();
  const [original, setOriginal] = useState('');
  const url = 'api/v1/links';

  const csrf = document.querySelector("meta[name='csrf-token']").getAttribute("content");

  function retrieveLinks() {
    fetch(url)
      .then((data) => {
        if (data.ok) {
          return data.json();
        }
        throw new Error("Network error.");
      })
      .then((data) => {
        setLinks(data);
      })
      .catch((err) => message.error("Error: " + err));
  }

  useEffect(() => {
    retrieveLinks();
  }, [original]);

  function createLink() {
    fetch(url, {
      method: 'post',
      headers: {
        'Content-Type':'application/json',
        'X-CSRF-Token': csrf
      },
      body: JSON.stringify({
        'original': original
      })
    })
      .then((response) => {
        if(!response.ok) throw new Error(response.status);
        else retrieveLinks;
      })
      .catch((error) => {
        console.log('error: ' + error);
      });

    ;
  }

  return (
    <div>
      <div>
        <AppBar position="static">
          <Toolbar variant="dense">
            <Typography variant="h6" color="inherit">
              My Shortner
            </Typography>
          </Toolbar>
        </AppBar>
        <Input value={original} defaultValue={original} placeholder='Insert a URL to get a shortned version' inputProps={{ 'aria-label': 'Insert a URL to get a shortned version' }} fullWidth={true} onChange={(value) => { value.target.value && setOriginal(value.target.value) }}/>
        <Button variant="contained" color="primary" disableElevation label="Short" onClick={({ message }) => {
          createLink();
          setOriginal('');
        }}> Short </Button>
      </div>
      <div style={{ maxWidth: "100%" }}>
        {links && <MaterialTable
          options={{
            pageSize: 20,
            selection: false,
            paginationType: "normal",
            pageSizeOptions: [5, 10, 20],
            sorting: false,
            search: false,
            emptyRowsWhenPaging: false,
            showFirstLastPageButtons: true,
            draggable: false,
            rowStyle: (data, index) => {
              if (index % 2) {
                return { backgroundColor: "#f1f1f1" };
              }
            },
          }}

          columns={[
            { title: "Original", field: "original" },
            { title: "Shortned", field: "shortned", render: ({ shortned }) =>  <a href={shortned}>{shortned}</a> },
            { title: "Count", field: "access_count" },
            { title: "User who set it", field: "username" },
          ]}
          data={links}
          title="Links"
          components={{
            Pagination: (props) => {
              return (
                <TablePagination
                  component="div"
                  backIconButtonProps={{ 'aria-label': '<' }}
                  nextIconButtonProps={{ 'aria-label': '>' }}
                  labelRowsPerPage='Per page: '
                  labelDisplayedRows={({ from, to, count }) => `${from}-${to} from ${count}`}
                  count={links.length}
                  page={props.page}
                  rowsPerPage={props.rowsPerPage}
                  rowsPerPageOptions={props.rowsPerPageOptions}
                  onChangePage={props.onChangePage}
                  onChangeRowsPerPage={props.onChangeRowsPerPage}

                />
              )
            }
          }}
        />}
      </div>
    </div>
  )}


Links.propTypes = {
  name: PropTypes.string
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Links name="React" />,
    document.body.appendChild(document.createElement('div')),
  )
})
